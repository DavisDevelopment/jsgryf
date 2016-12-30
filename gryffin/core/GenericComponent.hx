package gryffin.core;

class GenericComponent<T:Entity> extends Component {
	public var actor(get, never):T;
	private inline function get_actor():T return untyped owner;
}
